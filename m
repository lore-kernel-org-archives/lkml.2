Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab1EXRHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 13:07:10 -0400
Received: from mail.virtall.com ([178.63.195.102]:52705 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576Ab1EXRHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 13:07:09 -0400
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 May 2011 13:07:08 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws; d=wpkg.org; h=message-id:date
	:from:mime-version:to:subject:content-type
	:content-transfer-encoding; q=dns; s=default; b=8ebittLRCqyUP40l
	Kh6pOAtDGIw5dHrEJiHc1yCB5EkPUJzKWKNbppuMctrAnfbM8zy3RO2LmNRSdbGh
	MNi/gDTaV9SxMXNOXoTnf+9wK+0Fnejd4c8LlfYgrpY9c6GzI1sJ5k4HMKwqhSZl
	xBY8LiGjoqiN7zBqj1bO/Ay3KSU=
Message-ID: <4DDBE405.7010208@wpkg.org>
Date: Tue, 24 May 2011 18:59:49 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.39, poulsbo/gma500, suspend broken?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that with 2.6.39 kernel, I can no longer successfully suspend 
a netbook with poulsbo/gma500 hardware.

I.e. the system does seem to suspend, but it's no longer possible to 
wake it by pressing keys (at least on Asus Aspire One 751h I use).


Is it a known limitation of poulsbo/gma500 (added to 2.6.39 - before 
that, I was using 2.6.35 with some closed drivers)?


-- 
Tomasz Chmielewski
http://wpkg.org
