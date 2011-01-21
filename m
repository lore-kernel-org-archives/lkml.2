Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab1AUDlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 22:41:23 -0500
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:64016 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751854Ab1AUDlW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 22:41:22 -0500
X-AuditID: 1209190f-b7c1dae000000a2b-45-4d390061d16c
Subject: Re: [PATCH 0/7] Nexus One Support
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <1295576730.4096.24.camel@Joe-Laptop>
Date: Thu, 20 Jan 2011 22:41:15 -0500
Cc: Daniel Walker <dwalker@codeaurora.org>, Dima Zavin <dmitriyz@google.com>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, davidb@codeaurora.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C4B33E70-E4B2-4C56-8C53-D9EFA283384D@mit.edu>
References: <1295555565-21563-1-git-send-email-dwalker@codeaurora.org> <AANLkTik+HCj9dkD2s4WgwCqKWCXDbdSnKDUbyGfYfaPr@mail.gmail.com> <1295571359.9236.53.camel@m0nster>  <1295574085.4096.6.camel@Joe-Laptop> <1295575123.9236.54.camel@m0nster> <1295576730.4096.24.camel@Joe-Laptop>
To: Joe Perches <joe@perches.com>
X-Mailer: Apple Mail (2.1082)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 20, 2011, at 9:25 PM, Joe Perches wrote:
> 
> The authors may be different, but the first git
> committer of the patch is different.
> 
> The committer is the person that does a git commit
> either directly with git commit or git am.
> 
> You should keep the original patch author names and
> add your own "Signed-off-by:" and not claim authorship
> of the patches themselves.
> 

For example, many people send me patches for the ext4 tree.

Even if I get the patches from somewhere else, say the SuSE RPM, I will try to determine the author, and use that as the author field in the patches.  If I put a

From: The Original Author <author@original.com>

in the patch before I suck it in using git am, it will use the original author in the Author field.   I will add my Signed-off-by, preserving the other Signed-off-by's, and my name will appear in the Committer field, which is as it should be.

-- Ted

