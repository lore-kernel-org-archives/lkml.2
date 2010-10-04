Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab0JDKH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 06:07:26 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59140 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab0JDKHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 06:07:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gHVcqRoRquPpEuwiLYVVjtKoxwbNPxFYu0wxNeToOrA+4WrW7Kl7DIuNGteTzkyWNp
         rDUL9hxRSORA5L5GiUyyMoclaSUSAmVJYpwl+cSqaK7Gt8nVcl5k3YsMRvEVBogsMMiI
         EU9cIJBBsqmKARlpIA+36LoT4fJqL5WuE4AUc=
Date: Mon, 4 Oct 2010 18:12:00 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Artur Baruchi <mail.baruchi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Information From Buffers
Message-ID: <20101004101200.GI5189@cr0.nay.redhat.com>
References: <AANLkTik-RXPfDK12m5OFmLf=gVL1x-h-aDcKX2nz6O3P@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik-RXPfDK12m5OFmLf=gVL1x-h-aDcKX2nz6O3P@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 03:27:04PM -0300, Artur Baruchi wrote:
>Hi Guys.
>
>I would like to get more information about how cache/buffers are being
>used by kernel. Is there a way to walk through the buffer_head list
>and get these details ?
>

In /proc/meminfo, there are "Buffers" and "Cached" fields, are they
what you are looking for?
