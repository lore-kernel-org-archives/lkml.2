Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab0ILSkq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 14:40:46 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49453 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab0ILSkp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 14:40:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=sZ8J7g/FpqdQS6rZJCq0UUh58HYcRR79AK/qiYmQy79k2TDZiNq3QNPHK06OIrBMNO
         /5cwrjueb8LmbYONB4odnkzM+qjkZW+z8fpE5Ims+br9Q71CdZKeLviWp66kCQESTwa6
         XxnwxaCgwj8XNuyovoxsk7bDyCKzU04rdSQtM=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [regression] *ERROR* timed out waiting for FORCE_DETECT in 36rc3 on i915
Date: Sun, 12 Sep 2010 20:40:39 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3; KDE/4.4.5; i686; ; )
Cc: Chris Wilson <chris@chris-wilson.co.uk>, intel-gfx@lists.freedesktop.org,
        Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org
References: <87mxrswddf.fsf@basil.nowhere.org>
In-Reply-To: <87mxrswddf.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009122040.40352.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 8 września 2010 o 15:53:16 Andi Kleen wrote:
> One of my test box with Intel graphics spews out a lot of
> 
> [drm:intel_crt_detect_hotplug] *ERROR* timed out waiting for FORCE_DETECT
> to go off

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=18332
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
