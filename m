Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762031Ab0HMSBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 14:01:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39272 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab0HMSBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 14:01:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=X8k8qdqjQ3/czu9xVrjqczdslHIyt99zmwIvJC1TOjeVxIDgQ7isONtlXnfCSJo/T6
         ks5XYauvHbiaS2QyrFJUB4e1RfXTev/E8tAPV07nMVQ7Bgi0QM6hkn4lrkwKpMWYi3oH
         +Rcn07kmWfYpspXW6Ql2JX8fg9eG73wchTHcI=
MIME-Version: 1.0
Date: Sat, 14 Aug 2010 02:01:47 +0800
Message-ID: <AANLkTime9NS3Bk-8ZpovRNy9iEGJxwYw=-aZ38JoRa_3@mail.gmail.com>
Subject: linux-2.6.35+ causes LVM to fail with " device-mapper: version ioctl
 failed: Inappropriate ioctl for device"
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>, lvm-devel@redhat.com,
        dm-devel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems one of these commits in
8357422d4bf33bc2c35884d4016c3fc9efbbc1d2 is causing LVM2
(LVM2.2.02.72) to fail.

Previously good logical volumes cannot be mounted anymore, and new one
cannot be created. All failed with the error ...

"device-mapper: version ioctl failed: Inappropriate ioctl for device"


Is there a new LVM2 for this new dm ioctl or the dm is not right?


Thanks,
Jeff.
