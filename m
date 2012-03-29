Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab2C2J55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 05:57:57 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59719 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab2C2J5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 05:57:50 -0400
Date: Thu, 29 Mar 2012 12:57:44 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: joeyli <jlee@suse.com>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acer-wmi: ignore missing Aspire 5741G keys
Message-ID: <20120329095744.GB3576@swordfish.minsk.epam.com>
References: <20120306123355.GA3904@swordfish.minsk.epam.com>
 <1331266669.10557.107.camel@linux-s257.site>
 <20120312101956.GA8522@swordfish.minsk.epam.com>
 <1331607878.10557.145.camel@linux-s257.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331607878.10557.145.camel@linux-s257.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (03/13/12 11:04), joeyli wrote:
> 
> Appreciate for your acpidump and dmidecode log, I keep it for regression
> check.
> 
> 

Sorry to buther, somehow I missed 0x85 KEY_TOUCHPAD_TOGGLE while preparing original
patch. Probably it got lost in atkbd error lines
	[ 5593.029779] atkbd serio0: Unknown key pressed (translated set 2, code 0x93 on isa0060/serio0).
	[ 5593.029788] atkbd serio0: Use 'setkeycodes e013 <keycode>' to make it known.
	[ 5593.043166] atkbd serio0: Unknown key released (translated set 2, code 0x93 on isa0060/serio0).
	[ 5593.043174] atkbd serio0: Use 'setkeycodes e013 <keycode>' to make it known.

Sent it to you titled `acer-wmi: add Aspire 5741G touchpad toggle key'.


	-ss
