Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab0C1Eqk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 00:46:40 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:48493 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab0C1Eqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 00:46:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=U0FgUAycIaQ0Dd0euLk+3O6pySkxBKA+5zaCBGURUfwmnPAp1LSl0Fja6EtFwWt2zx
         ZW56b8w0dxirmvSWfzrJlX6MfY7EZ3qaRzXgFSSZitEJItahfvX0g64rO2a/4jfrPqz6
         T4dWCS2lzwMf7c6D2RuI5IC2UTXG4aLI4Ha1U=
Message-ID: <4BAEDF2B.3020808@garzik.org>
Date: Sun, 28 Mar 2010 00:46:35 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Linux IDE mailing list <linux-ide@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, harry.zhang@amd.com,
       Shane Huang <Shane.Huang@amd.com>, turmlos@comcast.net,
       Tejun Heo <tj@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [RFT] ahci rebase in libata #upstream
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The 'upstream' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git

was just rebased.  This is the branch normally exported to linux-next, 
and is intended for merging into 2.6.35, when the merge window for 
2.6.35 opens.

This rebase merges in ahci changes from torvalds/linux-2.6.git into the 
major AHCI driver reorganization authored by Anton Vorontsov, which 
creates a new kernel module libahci.

Please test and make sure your ahci driver continues working as expected!

People who have authored patches for ahci, and have not received an 
"applied" email acknowledgment need to rebase and resend their changes 
on top of the new 'upstream' branch of libata-dev.git.

	Jeff




