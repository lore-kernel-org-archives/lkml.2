Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031073Ab1EXBCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 21:02:31 -0400
Received: from barracuda.fsl.cs.sunysb.edu ([130.245.126.20]:33597 "EHLO
	barracuda.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030717Ab1EXBC2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 21:02:28 -0400
X-ASG-Debug-ID: 1306198946-01c65a06b01864c0001-xx1T2L
X-Barracuda-Envelope-From: ezk@fsl.cs.sunysb.edu
X-Barracuda-RBL-Trusted-Forwarder: 130.245.126.16
Subject: Re: [PATCH 5/7] overlay filesystem (inode.c bad error path)
X-Barracuda-BWL-IP: 192.168.1.133
X-Barracuda-BBL-IP: 192.168.1.133
X-Barracuda-RBL-IP: 192.168.1.133
Mime-Version: 1.0 (Apple Message framework v1084)
X-ASG-Orig-Subj: Re: [PATCH 5/7] overlay filesystem (inode.c bad error path)
Content-Type: text/plain; charset=us-ascii
From: Erez Zadok <ezk@fsl.cs.sunysb.edu>
In-Reply-To: <b11ac28b818740a8b3f619e756735e41@HUBCAS2.cs.stonybrook.edu>
Date: Mon, 23 May 2011 21:02:24 -0400
Cc: "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "nbd@openwrt.org" <nbd@openwrt.org>, "neilb@suse.de" <neilb@suse.de>,
        "hramrach@centrum.cz" <hramrach@centrum.cz>,
        "jordipujolp@gmail.com" <jordipujolp@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <B7D82117-02A5-4C33-A6B0-C231809FC8C7@fsl.cs.sunysb.edu>
References: <1305635452-14835-1-git-send-email-miklos@szeredi.hu> <103d3f78e2d3478d8bb93f5dda3a4a08@HUBCAS1.cs.stonybrook.edu> <D8301738-5094-4666-8C4D-E26425F1AD66@fsl.cs.sunysb.edu> <87wrhlah1e.fsf@tucsk.pomaz.szeredi.hu> <7dcd9c4e62864bc6aae66f5a4e3f3752@HUBCAS1.cs.stonybrook.edu> <2983EA36-BB3B-4AE3-9CAA-5A3C2D884DCF@fsl.cs.sunysb.edu> <b11ac28b818740a8b3f619e756735e41@HUBCAS2.cs.stonybrook.edu>
To: Miklos Szeredi <miklos@szeredi.hu>
X-Mailer: Apple Mail (2.1084)
X-Barracuda-Connect: avatar.fsl.cs.sunysb.edu[130.245.126.16]
X-Barracuda-Start-Time: 1306198946
X-Barracuda-URL: http://130.245.126.20:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64622
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 23, 2011, at 4:57 AM, Miklos Szeredi wrote:

> Erez Zadok <ezk@fsl.cs.sunysb.edu> writes:
> 
>> Are you interested in testing overlayfs on top of NFS at this time?
> 
> No, not as an upper layer.  NFS as a lower layer should work fine.

OK, I'll give it a test as well (careful what you wish for :-)

BTW, when do you typically sync up w/ Linus's tree: is it only when you release the next ovl version?

> Thanks,
> Miklos

Erez.

