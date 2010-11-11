Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab0KKL0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 06:26:20 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62203 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755959Ab0KKL0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 06:26:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=iLDhHqpz/9usdbg4WguOt8I3eCaHzYZ52ih3gDF5wX6FYqyQnMczl02pJkvW9V6eZs
         X5gHjE1TxEsDzDkBmDZiiQjU3srRL8OigWcjrzvE7tf07QQqbC4LDECQ8FRhUJBKy4ml
         H6uMxJhCEMsUfxkss/ViTYO4BVnjql4sZOBJo=
MIME-Version: 1.0
Date: Thu, 11 Nov 2010 09:26:17 -0200
Message-ID: <AANLkTinPX0by5GMTUbbEkb_WeayfY0hBzjYxrZM7asaY@mail.gmail.com>
Subject: mem_map array on NUMA
From: Artur Baruchi <mail.baruchi@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Im developing a module that get some information about memory pages.
This module worked fine on non-NUMA machine, I was able to walk
through the memory using the mem_map array. But, when I tried to
compile this module in a NUMA machine, the mem_map is not beeing
exported and I cannot use it.

Does anybody knows what can be used to substitute the mem_map array in
a NUMA machine ? Im using the kernel 2.6.35, and the
comments/documentations for newer kernels seems to be outdated.

Thanks in advance.

Att.
Artur Baruchi
