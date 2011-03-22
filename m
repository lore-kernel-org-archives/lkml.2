Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab1CVRHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 13:07:00 -0400
Received: from kroah.org ([198.145.64.141]:53685 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756411Ab1CVRG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 13:06:57 -0400
Date: Tue, 22 Mar 2011 10:04:19 -0700
From: Greg KH <greg@kroah.com>
To: nidhi mittal hada <nidhimittal19@gmail.com>
Cc: Xiaofan Chen <xiaofanc@gmail.com>, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: usb-serial gadget -- windows xp not working
Message-ID: <20110322170419.GC16244@kroah.com>
References: <AANLkTimwa4hvTzX+S1E08rwUKYrGB76GiZoE5LhHjGyu@mail.gmail.com>
 <AANLkTikQW__eD5v59BqWOrzMoW5NVPDwkNYG2vfgRhjy@mail.gmail.com>
 <AANLkTimk=3gi1bEomL1k0kcN2SMUOiAKQ7SBNKg3kYGX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimk=3gi1bEomL1k0kcN2SMUOiAKQ7SBNKg3kYGX@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 10:59:43AM +0530, nidhi mittal hada wrote:
> could you please tell What is the maximum speed we can get from the
> usb-serial transmission in bits/sec ............?

That depends on your hardware.  Test it yourself and see.

good luck,

greg k-h
