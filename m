Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab0DOMDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 08:03:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57970 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752142Ab0DOMDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 08:03:20 -0400
Date: Thu, 15 Apr 2010 13:06:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jean Delvare <khali@linux-fr.org>
Cc: Samu Onkalo <samu.p.onkalo@nokia.com>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH 0/1] BH1770GLC / SFH7770 combined ambient
 light  / proximity sensor
Message-ID: <20100415130653.083c2e56@lxorguk.ukuu.org.uk>
In-Reply-To: <20100415132643.415bac9f@hyperion.delvare>
References: <1271327648-13497-1-git-send-email-samu.p.onkalo@nokia.com>
	<20100415132643.415bac9f@hyperion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Apr 2010 13:26:43 +0200
Jean Delvare <khali@linux-fr.org> wrote:

> On Thu, 15 Apr 2010 13:34:07 +0300, Samu Onkalo wrote:
> > This patch introduces driver for Rohm BH1770GLC and Osram SFH7770
> > combined ambient light and proximity sensor.
> 
> I fail to see why this is being sent to the lm-sensors list.

For the same reason as lots of others are I imagine - because Linus
stopped them going somewhere sensible of their own ?
