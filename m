Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab1CCXTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 18:19:40 -0500
Received: from mail.candelatech.com ([208.74.158.172]:51767 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab1CCXTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 18:19:39 -0500
Message-ID: <4D70220A.9040100@candelatech.com>
Date: Thu, 03 Mar 2011 15:19:38 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Compile failure 'Bad ELF' ??
References: <4D701D88.2030709@candelatech.com>
In-Reply-To: <4D701D88.2030709@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2011 03:00 PM, Ben Greear wrote:
> I just merged in wireless-testing 2.6.38-rc7 and I'm getting
> a strange build error. This tree has a bunch of my own hacks
> in it too...

Bleh, my fault.  I didn't realize I was using a shell that had previously
defined CC to be mingw.  Guess you can't cross-compile Linux to
windows :)

Sorry.

Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

