Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab1CIOIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 09:08:43 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58311 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600Ab1CIOIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 09:08:40 -0500
Message-ID: <4D778993.3040902@ru.mvista.com>
Date: Wed, 09 Mar 2011 17:07:15 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Robin Becker <replabrobin@gmail.com>
CC: kernel@wantstofly.org, nico@fluxnic.net, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        replabrobin <robin@reportlab.com>
Subject: Re: [PATCH] stable: sheevaplug-setup.c fix LED color name and add
 support for second LED This is a patch to the sheevaplug-setup.c file that
 fixes the color name of the existing health LED. That LED gpio 49 is green
 when off and blue when on. The patch also adds support for the second LED
 that is green when off and red when on. Signed-off-by: Robin Becker <robin@reportlab.com>
References: <1299677239-3352-1-git-send-email-robin@reportlab.com>
In-Reply-To: <1299677239-3352-1-git-send-email-robin@reportlab.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09-03-2011 16:27, Robin Becker wrote:

> From: replabrobin <robin@reportlab.com>

    Real name is required in signoff.

WBR, Sergei
