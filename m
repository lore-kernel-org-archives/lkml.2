Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333Ab2HPUuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 16:50:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49373 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932636Ab2HPUud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 16:50:33 -0400
Date: Thu, 16 Aug 2012 13:50:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, olaf@aepfle.de, apw@canonical.com,
        ben@decadent.org.uk
Subject: Re: [PATCH V2 04/18] Drivers: hv: kvp: Support the new IP injection
 messages
Message-ID: <20120816205029.GA9176@kroah.com>
References: <1344877584-21738-1-git-send-email-kys@microsoft.com>
 <1344877627-21779-1-git-send-email-kys@microsoft.com>
 <1344877627-21779-4-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344877627-21779-4-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 10:06:53AM -0700, K. Y. Srinivasan wrote:
> +	default:
> +		utf16s_to_utf8s((wchar_t *)in->kvp_ip_val.adapter_id,
> +				MAX_ADAPTER_ID_SIZE,
> +				UTF16_LITTLE_ENDIAN,
> +				(__u8 *)out->body.kvp_ip_val.adapter_id,
> +				MAX_ADAPTER_ID_SIZE);
> +
> +		out->body.kvp_ip_val.addr_family =
> +		in->kvp_ip_val.addr_family;

That's some wierd indenting, did you really mean to do that?

greg k-h
