Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab0KYKrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 05:47:00 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64732 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab0KYKq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 05:46:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=HrimFVy1gPj6IHNBzWqdxMGro/RVmahu+jVUW1AgYR1rMS7lNZJvOdNbaT5V1vvQlQ
         iWbBkJC3Cqe0Ondg2X+CW0W/7K9N0io0sE6jdNGO2DfnoRGDmKzj3oQVshEPZcJ3YpTx
         BeMBzflvhG3jjPnePrfuSD35IBBxAOVA7ZR+s=
MIME-Version: 1.0
In-Reply-To: <AANLkTikXcz8WP5+Pp0W5PNrAaNsUUZWtGAAozT2HfvXM@mail.gmail.com>
References: <AANLkTikBeyM3Y2PZ_ZkMxsO0uLvqYq=BGWQpAis4MyHp@mail.gmail.com>
	<AANLkTikXcz8WP5+Pp0W5PNrAaNsUUZWtGAAozT2HfvXM@mail.gmail.com>
Date: Thu, 25 Nov 2010 11:46:25 +0100
Message-ID: <AANLkTikb1FUCT8V+kig1jUqJ8XfFOFecVODadm_XCCzz@mail.gmail.com>
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
