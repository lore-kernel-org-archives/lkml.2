Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab2DTLgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 07:36:33 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:47434 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755571Ab2DTLgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 07:36:32 -0400
Message-ID: <4F9149D8.9060600@mvista.com>
Date: Fri, 20 Apr 2012 15:34:48 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Yuri Matylitski <ym@tekinsoft.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <jhovold@gmail.com>,
        Preston Fick <preston.fick@silabs.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kirill@shutemov.name
Subject: Re: [PATCH] Fixed too small hardcoded timeout values for usb_control_msg
 in driver for SiliconLabs cp210x-based usb-to-serial adapters. Replaced with
 USB_CTRL_GET_TIMEOUT/USB_CTRL_SET_TIMEOUT.
References: <1334910722-7357-1-git-send-email-ym@tekinsoft.com>
In-Reply-To: <1334910722-7357-1-git-send-email-ym@tekinsoft.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 20-04-2012 12:32, Yuri Matylitski wrote:

    Your subject is far too long. Part of it probabbly should constitute the 
change log.

> Signed-off-by: Yuri Matylitski<ym@tekinsoft.com>

WBR, Sergei
