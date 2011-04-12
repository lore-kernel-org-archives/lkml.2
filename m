Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab1DLPA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 11:00:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65053 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774Ab1DLPAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 11:00:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:content-type;
        b=Ic8JUGRXS3Z3N9oG6422U5Cxb9MKsMBKe4hiIE3DHfJ8XHdlJi6HwSSlppfcAKxZBH
         5nThXQJuVBi/qG1fD7OFhpb1+VRF4AG2LN+tnH0xR+XyH4dD8qGL8IfeB+0swrPBOABY
         75q/ZENWO8CekRcHum1mVpcb2ez90AnjGBGUk=
MIME-Version: 1.0
From: Michal Suchanek <hramrach@centrum.cz>
Date: Tue, 12 Apr 2011 17:00:03 +0200
X-Google-Sender-Auth: qa-ZwH1vQMPfzxEW06y4-lr0mIg
Message-ID: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
Subject: Unionmount status?
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

as some already know the Unionmount VFS union which has been in
development for some years now is the only True Union (TM) that can be
accepted into the kernel mainline by the VFS maintainers (for reasons
of their own which you can surely find if you search the web or ask
them directly).

The current UnionMount version that can be found here:

http://git.kernel.org/?p=linux/kernel/git/val/linux-2.6.git;a=shortlog;h=refs/heads/ext2_works

works for me as good as aufs does. That is I can build a live CD using
this unioning solution and it boots and runs without any apparent
issues.

There are probably many possible uses of the union which I did not
test nor did I test long term stability of using the unioned
filesystem. As far as ephemeral live systems go it works fine for me,
though.

The issue is that while the code is (nearly) finished it is not yet
merged into mainline and as I am not familiar with the details of
ever-changing Linux VFS layer forward-porting this code to current
kernels is somewhat challenging.

What is the plan with unionmount now?

What is required  for it to be merged into mainline?

Thanks

Michal
