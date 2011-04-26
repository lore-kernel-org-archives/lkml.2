Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab1DZPlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 11:41:44 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41914 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab1DZPlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 11:41:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=jEhJ+OXW6GydQrL7Ub63PCb3sAl/Iuil1CceYsLSGLd3iEfoouJEv04Grqkk9z1WLo
         xGO5HFrdffaEAuOr1bTPlJIOc3lO+Ik8WQ+W+bz1P6WdBvrfD+pn8iuW3So0FjSWVoC4
         wWOaE86/i+qeMn/ftpcXDL+ftVPskhuighWSY=
MIME-Version: 1.0
Date: Wed, 27 Apr 2011 00:41:42 +0900
Message-ID: <BANLkTinvXgy+c-xB2HZmkAfE7JPdbBPF+A@mail.gmail.com>
Subject: How to deal with interrupt on HW without interrupt pin?
From: Adam Jiang <jiang.adam@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, list

I have a weird hardware module on my board. According to the
schematics, there is no pins(there should be, but missed by some
reason) connected to CPU for notifications of interrupt. However,
interrupt status and mask registers on the module could be accessed
with i2c interface. Is there an efficient way to know when the
interrupt occurred? Are there any good example for this? Thanks.

/Adam
