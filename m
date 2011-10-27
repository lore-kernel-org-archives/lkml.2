Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab1J0UNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 16:13:00 -0400
Received: from smtp-out.google.com ([74.125.121.67]:5025 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab1J0UM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 16:12:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=XYoxEKq8UnB8Hfc6EUOgvWCRyZeK9h+29vb30BtInkjmEYJCSbsMJKy3qbbj3iBEZ
	r3lgTarPgsF9qWsP4TC+Q==
Date: Thu, 27 Oct 2011 13:12:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: werner <w.landgraf@ru.ru>
cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        dave.taht@gmail.com, arend@broadcom.com, toralf.foerster@gmx.de,
        wey-yi.w.guy@intel.com, ilw@linux.intel.com, larry.finger@gmail.com
Subject: Re: 3.1-rc9 and 3.1 wifi problem , problem continues with 3.1
In-Reply-To: <web-634287632@zbackend1.aha.ru>
Message-ID: <alpine.DEB.2.00.1110271312280.7639@chino.kir.corp.google.com>
References: <web-634287632@zbackend1.aha.ru>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Oct 2011, werner wrote:

> With the patch sent by Guy, Wey-Yi W , now wifi works at that laptop.
> 

Could you send a pointer to the exact patch(es) that you applied so we can 
add your tested-by?

Thanks for testing!
