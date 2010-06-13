Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750951Ab0FMEdl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 00:33:41 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43036 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab0FMEdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 00:33:40 -0400
MIME-Version: 1.0
X-Originating-IP: [67.185.128.239]
Date: Sat, 12 Jun 2010 21:33:39 -0700
Message-ID: <AANLkTilZkfvBiwliJ6JKXfvS0V3cvO_AAIj6quegvYgq@mail.gmail.com>
Subject: Testing to see if a driver is loaded
From: Robert Emanuele <rob@emanuele.us>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings once again,

I was wondering if there is a simple way to test if a driver is loaded
from within another driver's probe?  I have one driver that depends on
another.  I see several *_find_device functions in
include/linux/device.h.  I haven't found a "find driver" nor an
arbitrary way of doing that.

Thanks for any guidance,

Rob
