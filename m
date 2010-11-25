Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab0KYKqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 05:46:47 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59641 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab0KYKqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 05:46:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=Cn0f4Y9MxRFr8aelC3oKZbhf5iZtvgo4JtAN7wHtrlaN1kLJDgPUKnqId3k17Q6pWD
         YOUv+ES5aaVzZ3OG7xtv8nueVaLj48M0+/ZKEGKkkBju54rIhHGRX+jQXzXr3fLPBhO/
         SjToTJYjRQfti74eTUjvBXNkHyYVdDobqO9Ho=
MIME-Version: 1.0
In-Reply-To: <AANLkTikXcz8WP5+Pp0W5PNrAaNsUUZWtGAAozT2HfvXM@mail.gmail.com>
References: <AANLkTikBeyM3Y2PZ_ZkMxsO0uLvqYq=BGWQpAis4MyHp@mail.gmail.com>
	<AANLkTikXcz8WP5+Pp0W5PNrAaNsUUZWtGAAozT2HfvXM@mail.gmail.com>
Date: Thu, 25 Nov 2010 11:46:45 +0100
Message-ID: <AANLkTi=h0wznUcA-fH9bF1pJDJEgvKoOaCMifMNJggZj@mail.gmail.com>
Subject: [driver] Marvell 9128
From: Alessandro Tagliapietra <tagliapietra.alessandro@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, i've a asus p6x58d-e motherboard with a Marver 9128 (1b4b:91a3)
Sata-6 controller. I've tried both ubuntu and fedora (that has newer
kernel) and both can't find the 2 western digital sata-6 drives
configured in raid0.

I've also searched in the lastest kernel source and i can't find
support for that piece of hardware.

I'm new to the kernel mailing list, what are the next steps?

Best regards

Alessandro Tagliapietra
