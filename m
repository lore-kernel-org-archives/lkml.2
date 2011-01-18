Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab1ARPdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 10:33:12 -0500
Received: from lo.gmane.org ([80.91.229.12]:43406 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab1ARPdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 10:33:10 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Frederik Himpe <fhimpe@telenet.be>
Subject: Re: [ANN] ulatencyd 0.3.1
Date: Tue, 18 Jan 2011 15:32:58 +0000 (UTC)
Message-ID: <ih4bra$i13$1@dough.gmane.org>
References: <4D357204.3090505@poelzi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: artipc9.vub.ac.be
User-Agent: Pan/0.133 (House of Butterflies)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jan 2011 11:57:08 +0100, Daniel Poelzleithner wrote:

> Hi all,
> 
> I'm happy to announce the release of ulatencyd 0.3.1

I'm getting this build error:

/home/frederik/Software/src/ulatencyd-0.3.1/src/ulatencyd.c: In function 
‘avoid_oom_killer’:
/home/frederik/Software/src/ulatencyd-0.3.1/src/ulatencyd.c:126: error: 
‘O_NOFOLLOW’ undeclared (first use in this function)
/home/frederik/Software/src/ulatencyd-0.3.1/src/ulatencyd.c:126: error: 
(Each undeclared identifier is reported only once
/home/frederik/Software/src/ulatencyd-0.3.1/src/ulatencyd.c:126: error: 
for each function it appears in.)

What could be the problem here? I'm using Debian Squeeze AMD64 with libc 
2.11.2-7 and Linux 2.6.37-trunk-amd64.

-- 
Frederik Himpe

