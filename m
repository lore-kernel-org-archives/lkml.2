Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab2CLTCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 15:02:22 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:51759 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200Ab2CLTCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 15:02:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=shealevy.com;
	 b=MAb9DWH+zlTxyTZ2eDgcwpt7GyhP7naDLHEsp5HisNpT73FM417nLmFgA8j+p
	oQoOurdycx9PykkMK5PwS/Kem9Q4M05Bs4qqsLytGtH8h4rwhKcTXGtjaqGd2M7Z
	D5coBBJcvFXcvC8CuAcT0m6AiWTQMYHlkm16NZ/mGbMd0w=
Message-ID: <4F5E47E4.2070303@shealevy.com>
Date: Mon, 12 Mar 2012 15:00:52 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: matt.fleming@intel.com
Subject: Re: EFI Boot Stub Early Console
References: <4F5E46EA.7020602@shealevy.com>
In-Reply-To: <4F5E46EA.7020602@shealevy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/12 2:56 PM, Shea Levy wrote:
> console=tty0

Sorry, that should have been console=ttyS0
