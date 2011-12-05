Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab1LEVv4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 16:51:56 -0500
Received: from hera.cwi.nl ([192.16.191.8]:33353 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932372Ab1LEVvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 16:51:54 -0500
Message-ID: <4EDD3CED.70705@cwi.nl>
Date: Mon, 05 Dec 2011 21:51:41 +0000
From: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>, gregkh@suse.de,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [usb] kernel BUG at arch/x86/mm/physaddr.c:15
References: <4ED8B66F.9020705@cwi.nl> <20111205203057.GA24674@kroah.com>
In-Reply-To: <20111205203057.GA24674@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Your patch seems to solve the issue. Rebooted six times, both hot and 
cold, and no crash.

Tested-by: Wouter M. Koolen <wmkoolen@cwi.nl>

Cheers,

Wouter

On 12/05/2011 08:30 PM, Greg KH wrote:
> Ick, ok, can you try the patch here and let me know if that solves it or
> not?
>
