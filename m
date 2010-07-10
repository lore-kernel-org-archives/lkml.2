Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab0GJVzu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 17:55:50 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51388 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab0GJVzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 17:55:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Al6hOKpdlR3GZVoeUj8iBA7NAHbP3n83D/d4RPLwQ+Vg/fqElFiBUQLtCNHMXZ8Qhx
         8ZwxAqgWjOuQf0rlKZ5Jef9zVHnGC5T8HsfeO2nEjG9hw7Pq4DRIryJVRxea5q+CrvQ2
         mMyF3dWOO3/u2Qex5BxdNpChM6mEWL4CtRbwg=
MIME-Version: 1.0
Date: Sat, 10 Jul 2010 17:55:48 -0400
Message-ID: <AANLkTilvP8WDEyyZhNOraBtCeRk1ru1TmryFfEppTHB3@mail.gmail.com>
Subject: Calling system call from User-mode Linux?
From: Philip Wernersbach <philip.wernersbach@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to add some functionality to User-mode Linux that requires
the UML kernel to call a custom syscall I've added to the host kernel.
This should be technically possible since UML runs in the userspace,
but I can't figure out how to call the syscall, as the syscall()
function isn't defined in UML. Are there other ways I can accomplish
this?

Thanks,
Phil
