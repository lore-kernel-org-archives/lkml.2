Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004Ab0DNVjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 17:39:35 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42166 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756955Ab0DNVje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 17:39:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:user-agent:x-archive:mime-version
         :content-type;
        b=sVIyjnurXy+WN/62vNHa2Ltj1KC1RExHcXPWMVTZVa52Bs7yq/ecDyKJZ/5LRrzX0y
         hgY+/I6F4QOGlJr/4UI73xPPdWlwMm91Qp15PWHdaw8t9bytTB3ocICDlmi+kv8LbAwX
         T893O19y7EIvIhTsJNALqQfIPsbAeMBZfe6X0=
Date: Wed, 14 Apr 2010 18:39:20 -0300 (BRT)
From: "=?ISO-8859-15?Q?Fr=E9d=E9ric_L=2E_W=2E_Meunier?=" 
	<fredlwm@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: it87 with 2.6.33.2: noise
Message-ID: <alpine.LNX.2.01.1004141835450.13955@dyndns.pervalidus.net>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
X-Archive: encrypt
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 2.6.33.2, as soon as it87 is loaded, my speaker (or 
something I couldn't identify) starts like an alarm/ring and 
doesn't stop until I reboot.

It didn't happen with 2.6.32.

Apr 14 18:27:37 pervalidus kernel: it87: Found IT8716F chip at 0x228, revision 3
