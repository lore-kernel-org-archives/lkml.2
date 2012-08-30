Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab2H3Ryx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 13:54:53 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:65475 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab2H3Ryu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 13:54:50 -0400
MIME-Version: 1.0
Date: Thu, 30 Aug 2012 14:48:33 -0300
Message-ID: <CAH0vN5Jn1g+zekr-Nd=GizskgbcOGj8zoq+m6OvBiO6Xkw5-UQ@mail.gmail.com>
Subject: Get the min and max frequency of a processor
From: Marcos Souza <marcos.souza.org@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi people,

I'm changing an application to get the min and max frequency of a
processor. The device is using cpufreq, and it will show the user  the
min and max frequency that we can overclock.

There is a way to get these values, instead of reading the /sys files,
or is this the solution?

Thanks for your time.

-- 
Att,

Marcos Paulo de Souza
Acadêmico de Ciencia da Computação - FURB - SC
"Uma vida sem desafios é uma vida sem razão"
"A life without challenges, is a non reason life"
