Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611Ab2EOL3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 07:29:25 -0400
Received: from mga12.intel.com ([143.182.124.36]:22737 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757653Ab2EOL3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 07:29:22 -0400
Subject: RE: [PATCH] Liberate the signal layer from IA64 assembler
From: Matt Fleming <matt.fleming@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F192EEF5D@ORSMSX104.amr.corp.intel.com>
References: <1337031869-14718-1-git-send-email-andi@firstfloor.org>
	 <3908561D78D1C84285E8C5FCA982C28F192EEF5D@ORSMSX104.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Tue, 15 May 2012 12:29:06 +0100
Message-ID: <1337081346.27692.17.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 22:00 +0000, Luck, Tony wrote:
> Adding Cc: linux-ia64

I'm obviously all for this patch given that I started the following
thread on linux-ia64 last year,

	http://www.spinics.net/lists/linux-ia64/msg08362.html

and *still* haven't found the time to write any ia64 assembly.

