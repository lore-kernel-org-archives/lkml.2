Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab2DRJIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 05:08:10 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:41452 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751558Ab2DRJII convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 05:08:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAFNq8R4U-1c4ONn8EDZ7-ZgO2BC0r1JvsBxKsD1MeBzRndJr-w@mail.gmail.com>
References: <CAFNq8R4U-1c4ONn8EDZ7-ZgO2BC0r1JvsBxKsD1MeBzRndJr-w@mail.gmail.com>
Date: Wed, 18 Apr 2012 17:08:07 +0800
Message-ID: <CAFNq8R4dF+QPvPcy5+SSOBketAdzyJfJ6WonX0Z8OHztcvsYvA@mail.gmail.com>
Subject: How does the driver initialize corresponding with several same
 devices ?
From: Li Haifeng <omycle@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I make a driver module and built in the kernel. There are three devices use
the same driver on the hardware platform. To use each device, the probe
function of the driver module should be probed. So, the driver module is
registered in the kernel.

My question is, how times should the probe function of the driver be called
and create nodes in devfs to corresponding with the three devices?
