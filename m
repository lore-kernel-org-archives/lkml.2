Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab1KWXnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 18:43:05 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59128 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab1KWXnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 18:43:04 -0500
MIME-Version: 1.0
Date: Thu, 24 Nov 2011 00:43:03 +0100
Message-ID: <CAGPN=9THOv-M4Td4haE94uDcsAjW3eGMG7ioLeu+p8xUOBPd7w@mail.gmail.com>
Subject: i915: 3.2 rc1/2 KMS regression
From: Patrik Kullman <patrik.kullman@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With the Asus Zenbook UX31E, kernel 3.1.1/2 works perfectly, but 3.2
rc1 and rc2 freezes on boot with KMS.

i915.modeset=0 makes the kernel boot but cripples the graphics.

Has this regression been noticed?
Any tree maintainer that can take a guess as to why I'm hitting this?
