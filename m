Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab0HSPIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 11:08:06 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45995 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab0HSPID convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 11:08:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=EJW9hScAsldkN34h5yT7tIDS0DYPE/MTj2nhP3dGHksbGK/kb0EEISdatQMe8daZYy
         oPkV7UYZg7Qcopvs7t9qX+zqv2KIaQeIE4BGCxPbZAHK2XBUsmM/KghdOn7VP3u7wQJt
         NrLRx5bY7rqN7CkW+8x3XsEwyjzD4caLaFbv8=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: trapdoor6@gmail.com
Subject: Re: [REGRESSION] [SUSPEND] Opps during suspend to disk (probably also during to ram)
Date: Thu, 19 Aug 2010 17:07:51 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc1; KDE/4.4.5; i686; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <201008182102.03201.maciej.rutecki@gmail.com> <AANLkTik3S91w+92rz-KdHd_U=yfuSPbDWWhD_Vu_rDR9@mail.gmail.com> <AANLkTik4=_3wSNpkfqssWsmG_yCYOPFsA-cMDBaVU4BB@mail.gmail.com>
In-Reply-To: <AANLkTik4=_3wSNpkfqssWsmG_yCYOPFsA-cMDBaVU4BB@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008191707.52057.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 18 sierpnia 2010 o 23:27:14 trapDoor wrote:

> 
> Maciej,
> Just FYI I have updated the bugzilla entry
> (https://bugzilla.kernel.org/show_bug.cgi?id=16615) with relevant
> details.

Patch works also on my machine, but I found another problem [1].

Thanks!
-- 
Maciej Rutecki
http://www.maciek.unixy.pl

[1] https://bugzilla.kernel.org/show_bug.cgi?id=16629
