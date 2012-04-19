Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab2DSPYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 11:24:04 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35952 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab2DSPYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 11:24:02 -0400
Message-ID: <4F902E05.30503@wwwdotorg.org>
Date: Thu, 19 Apr 2012 09:23:49 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Sourav Poddar <sourav.poddar@ti.com>
CC: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Subject: Re: [PATCHv2 1/2] drivers: input: keypad: Add device tree support
References: <1334848537-823-1-git-send-email-sourav.poddar@ti.com>
In-Reply-To: <1334848537-823-1-git-send-email-sourav.poddar@ti.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2012 09:15 AM, Sourav Poddar wrote:
> Update the Documentation with omap4 keypad device tree
> binding information.
> Add device tree support for omap4 keypad driver.
> 
> Tested on omap4430 sdp with 3.4-rc3.

> diff --git a/Documentation/devicetree/bindings/input/omap-keypad.txt b/Documentation/devicetree/bindings/input/omap-keypad.txt

> +- Keys represented as child nodes: Each key connected to the keypad
> +  controller is represented as a child node to the keypad controller
> +  device node and should include the following properties.
> +  - keypad,row: the row number to which the key is connected.
> +  - keypad,column: the column number to which the key is connected.
> +  - linux,code: the key-code to be reported when the key is pressed
> +    and released.

Shouldn't this use the common matrix keymap bindings;
Documentation/devicetree/bindings/input/matrix-keymap.txt
