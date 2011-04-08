Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab1DHEK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 00:10:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52853 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334Ab1DHEK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 00:10:57 -0400
Date: Fri, 8 Apr 2011 14:10:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: linux-next: manual merge of the wireless tree with Linus' tree
Message-Id: <20110408141054.2582833a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/net/wireless/zd1211rw/zd_rf_rf2959.c between commit 25985edcedea
("Fix common misspellings") from Linus' tree and commit fbd5d17b8e2b
("zd1211rw: rename CR* macros to ZD_CR*") from the wireless tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/zd1211rw/zd_rf_rf2959.c
index e361174,0325426..0000000
--- a/drivers/net/wireless/zd1211rw/zd_rf_rf2959.c
+++ b/drivers/net/wireless/zd1211rw/zd_rf_rf2959.c
@@@ -152,44 -152,44 +152,44 @@@ static int rf2959_init_hw(struct zd_rf 
  	struct zd_chip *chip = zd_rf_to_chip(rf);
  
  	static const struct zd_ioreq16 ioreqs[] = {
- 		{ CR2,   0x1E }, { CR9,   0x20 }, { CR10,  0x89 },
- 		{ CR11,  0x00 }, { CR15,  0xD0 }, { CR17,  0x68 },
- 		{ CR19,  0x4a }, { CR20,  0x0c }, { CR21,  0x0E },
- 		{ CR23,  0x48 },
+ 		{ ZD_CR2,   0x1E }, { ZD_CR9,   0x20 }, { ZD_CR10,  0x89 },
+ 		{ ZD_CR11,  0x00 }, { ZD_CR15,  0xD0 }, { ZD_CR17,  0x68 },
+ 		{ ZD_CR19,  0x4a }, { ZD_CR20,  0x0c }, { ZD_CR21,  0x0E },
+ 		{ ZD_CR23,  0x48 },
  		/* normal size for cca threshold */
- 		{ CR24,  0x14 },
- 		/* { CR24,  0x20 }, */
- 		{ CR26,  0x90 }, { CR27,  0x30 }, { CR29,  0x20 },
- 		{ CR31,  0xb2 }, { CR32,  0x43 }, { CR33,  0x28 },
- 		{ CR38,  0x30 }, { CR34,  0x0f }, { CR35,  0xF0 },
- 		{ CR41,  0x2a }, { CR46,  0x7F }, { CR47,  0x1E },
- 		{ CR51,  0xc5 }, { CR52,  0xc5 }, { CR53,  0xc5 },
- 		{ CR79,  0x58 }, { CR80,  0x30 }, { CR81,  0x30 },
- 		{ CR82,  0x00 }, { CR83,  0x24 }, { CR84,  0x04 },
- 		{ CR85,  0x00 }, { CR86,  0x10 }, { CR87,  0x2A },
- 		{ CR88,  0x10 }, { CR89,  0x24 }, { CR90,  0x18 },
- 		/* { CR91,  0x18 }, */
+ 		{ ZD_CR24,  0x14 },
+ 		/* { ZD_CR24,  0x20 }, */
+ 		{ ZD_CR26,  0x90 }, { ZD_CR27,  0x30 }, { ZD_CR29,  0x20 },
+ 		{ ZD_CR31,  0xb2 }, { ZD_CR32,  0x43 }, { ZD_CR33,  0x28 },
+ 		{ ZD_CR38,  0x30 }, { ZD_CR34,  0x0f }, { ZD_CR35,  0xF0 },
+ 		{ ZD_CR41,  0x2a }, { ZD_CR46,  0x7F }, { ZD_CR47,  0x1E },
+ 		{ ZD_CR51,  0xc5 }, { ZD_CR52,  0xc5 }, { ZD_CR53,  0xc5 },
+ 		{ ZD_CR79,  0x58 }, { ZD_CR80,  0x30 }, { ZD_CR81,  0x30 },
+ 		{ ZD_CR82,  0x00 }, { ZD_CR83,  0x24 }, { ZD_CR84,  0x04 },
+ 		{ ZD_CR85,  0x00 }, { ZD_CR86,  0x10 }, { ZD_CR87,  0x2A },
+ 		{ ZD_CR88,  0x10 }, { ZD_CR89,  0x24 }, { ZD_CR90,  0x18 },
+ 		/* { ZD_CR91,  0x18 }, */
 -		/* should solve continous CTS frame problems */
 +		/* should solve continuous CTS frame problems */
- 		{ CR91,  0x00 },
- 		{ CR92,  0x0a }, { CR93,  0x00 }, { CR94,  0x01 },
- 		{ CR95,  0x00 }, { CR96,  0x40 }, { CR97,  0x37 },
- 		{ CR98,  0x05 }, { CR99,  0x28 }, { CR100, 0x00 },
- 		{ CR101, 0x13 }, { CR102, 0x27 }, { CR103, 0x27 },
- 		{ CR104, 0x18 }, { CR105, 0x12 },
+ 		{ ZD_CR91,  0x00 },
+ 		{ ZD_CR92,  0x0a }, { ZD_CR93,  0x00 }, { ZD_CR94,  0x01 },
+ 		{ ZD_CR95,  0x00 }, { ZD_CR96,  0x40 }, { ZD_CR97,  0x37 },
+ 		{ ZD_CR98,  0x05 }, { ZD_CR99,  0x28 }, { ZD_CR100, 0x00 },
+ 		{ ZD_CR101, 0x13 }, { ZD_CR102, 0x27 }, { ZD_CR103, 0x27 },
+ 		{ ZD_CR104, 0x18 }, { ZD_CR105, 0x12 },
  		/* normal size */
- 		{ CR106, 0x1a },
- 		/* { CR106, 0x22 }, */
- 		{ CR107, 0x24 }, { CR108, 0x0a }, { CR109, 0x13 },
- 		{ CR110, 0x2F }, { CR111, 0x27 }, { CR112, 0x27 },
- 		{ CR113, 0x27 }, { CR114, 0x27 }, { CR115, 0x40 },
- 		{ CR116, 0x40 }, { CR117, 0xF0 }, { CR118, 0xF0 },
- 		{ CR119, 0x16 },
+ 		{ ZD_CR106, 0x1a },
+ 		/* { ZD_CR106, 0x22 }, */
+ 		{ ZD_CR107, 0x24 }, { ZD_CR108, 0x0a }, { ZD_CR109, 0x13 },
+ 		{ ZD_CR110, 0x2F }, { ZD_CR111, 0x27 }, { ZD_CR112, 0x27 },
+ 		{ ZD_CR113, 0x27 }, { ZD_CR114, 0x27 }, { ZD_CR115, 0x40 },
+ 		{ ZD_CR116, 0x40 }, { ZD_CR117, 0xF0 }, { ZD_CR118, 0xF0 },
+ 		{ ZD_CR119, 0x16 },
  		/* no TX continuation */
- 		{ CR122, 0x00 },
- 		/* { CR122, 0xff }, */
- 		{ CR127, 0x03 }, { CR131, 0x08 }, { CR138, 0x28 },
- 		{ CR148, 0x44 }, { CR150, 0x10 }, { CR169, 0xBB },
- 		{ CR170, 0xBB },
+ 		{ ZD_CR122, 0x00 },
+ 		/* { ZD_CR122, 0xff }, */
+ 		{ ZD_CR127, 0x03 }, { ZD_CR131, 0x08 }, { ZD_CR138, 0x28 },
+ 		{ ZD_CR148, 0x44 }, { ZD_CR150, 0x10 }, { ZD_CR169, 0xBB },
+ 		{ ZD_CR170, 0xBB },
  	};
  
  	static const u32 rv[] = {
