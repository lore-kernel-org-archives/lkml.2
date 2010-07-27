Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab0G0Oqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 10:46:48 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:52632 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251Ab0G0Oqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 10:46:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:content-type;
        b=rM/vhDcF3PmwJdMuTwLvInnehmjk5kkr38FPhkvh1uoVDX0E6sKD6VKUojK1m6bn5l
         txwUgTyEtczUBCHMp9mY31e7xNDkLXgGngcK1BZ8zHwqSfVBcef4khEadj0sEG6Jp8xE
         0/qrNsNHuqRf3m1pCnUgjJ69j7eTGJkSwd8lA=
MIME-Version: 1.0
Reply-To: trapdoor6@gmail.com
Date: Tue, 27 Jul 2010 15:46:45 +0100
Message-ID: <AANLkTi=ON+60QM9Ooepwr7FLr+RV1TN6X-6D78tuNfCS@mail.gmail.com>
Subject: Small typo in kernel [current source from git] .config option
From: trapDoor <trapdoor6@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I've just got lucky and found this little typo under "Power management
and ACPI options"  ---> "ACPI (Advanced Configuration and Power
Interface) Support":
hArdware Error Device

Here is my fix:
Hardware Error Device
:)

BTW, first time I've used nconfig instead of menuconfig. And I like it.

-- 
Regards
trapDoor
