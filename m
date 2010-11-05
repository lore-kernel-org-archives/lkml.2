Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab0KEMTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 08:19:01 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35626 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab0KEMS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 08:18:59 -0400
Date: Fri, 5 Nov 2010 14:19:17 +0200
From: Felipe Balbi <balbi@ti.com>
To: Rahul Ruikar <rahul.ruikar@gmail.com>
Cc: "Balbi, Felipe" <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Ming Lei <tom.leiming@gmail.com>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        Mike Frysinger <vapier@gentoo.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: musb: musb_gadget: Fix error path
Message-ID: <20101105121917.GW1952@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1286001348-3645-1-git-send-email-rahul.ruikar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1286001348-3645-1-git-send-email-rahul.ruikar@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 02, 2010 at 01:35:48AM -0500, Rahul Ruikar wrote:
>In function musb_gadget_setup()
>call put_device() when device_register() fails.
>
>Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>

applied, thanks

-- 
balbi
