Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab0GUL3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 07:29:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56364 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab0GUL3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 07:29:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:content-type;
        b=YViEyowqJQYO6Il8miPtIDwWoOKSXpLbZOC/qqp0Mwqlmo3EIKV8KNqrfyCdiMhu7J
         F9AH1d97diuH1kN2fOEtsfehskwBmPgH1yGKiLQT/GzNobF7EJBZzHY3rxei+UBMujS7
         lcbp8e9lRNSLL9TyQqCydTLtoqzwF3Ub9Om6k=
MIME-Version: 1.0
Reply-To: trapdoor6@gmail.com
Date: Wed, 21 Jul 2010 12:29:52 +0100
Message-ID: <AANLkTim9-79EImktArUO2td5nqUAtp-Uag3j4BDzj_-E@mail.gmail.com>
Subject: Kernel bisect: a query regarding commit identifiers
From: trapDoor <trapdoor6@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,
Just a quick question. I'm going to do kernel bisect and was wondering
if there are commit identifiers for the rc-GIT versions ? Or maybe I
won't need it and could just do it like this:
git-bisect bad 2.6.35-rc2-git3
git-bisect good 2.6.35-rc2-git4

?

Identifiers for rc versions appear in changelogs but I can't find
identifiers for the rc-git's. I think that doing bisect between rc-git
version within the same rc would save me some time. Assuming I will be
able to narrow a problem down to a particular rc initially ..

-- 
Regards
trapDoor
