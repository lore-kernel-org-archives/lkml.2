Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab1DTAro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 20:47:44 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47917 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab1DTArn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 20:47:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=kVnWhE1eWwd4E+QzCzXSVrerapsJ51tzN8KwsJc8IK5vr1Kgm2FdwGe64ZFwZjN7tG
         Me+aRcs/mw9EaUFWCfiRKbX/TUC4/6Rw0t6G0yas4+Zc02m2RVC++BQpBBkiEgwRo65d
         b14TMlrkvMVOYLnr9OPzS2S9BUGWC+vC106Kk=
MIME-Version: 1.0
Date: Wed, 20 Apr 2011 09:47:41 +0900
Message-ID: <BANLkTin7Lwf18B=WLBgHP+dUgDOYoXF1BA@mail.gmail.com>
Subject: "man acl" contains wrong information. It could be a kernel bug.
From: crocket <crockabiscuit@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"CHANGES TO THE FILE UTILITIES" section in "man acl" is largely wrong.

I know that it should be mentioned in coreutils mailing list, but I
think kernel could be related, too.
1) Files don't have default ACL.
2) -p flag of cp is written to preserve ACL. But whose ACL does it preserve?
Is it destination directory's ACL or original file's ACL?
3) mv is said to preserve ACL. Does it mean the moved file's ACL or
destination directory's ACL?

Could it be a kernel bug that cp doesn't respect destination directory's ACL?
