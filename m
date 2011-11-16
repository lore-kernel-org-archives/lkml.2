Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab1KPPiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 10:38:00 -0500
Received: from smtprelay01.ispgateway.de ([80.67.31.28]:47072 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab1KPPh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 10:37:59 -0500
Message-ID: <4EC3D8D4.7020304@ladisch.de>
Date: Wed, 16 Nov 2011 16:37:56 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: "Paul Barbu Gh." <paullik.paul@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: No sound after updating to 3.1.0-4
References: <4EBEA50C.9070209@gmail.com>
In-Reply-To: <4EBEA50C.9070209@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Barbu Gh. wrote:
> After 9 Nov 2011 kernel update to 3.1.0-4 in ArchLinux I get no sound
> output(headphones and speakers), I checked alsamixer and pavucontrol and
> everything seems OK.

Please get the contents of /proc/asound/card0/codec* with the old and
new kernels, and post it to <alsa-devel@alsa-project.org>.


Regards,
Clemens
