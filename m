Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab0H3NGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 09:06:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57930 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab0H3NGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 09:06:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=d03iXxuIkn87UquMn4yt3Xl3uuRWpOFdrsIW60goApWwrTBa19QyIbmIn44CA7fmwL
         cSx7CpuKhi94Ov9fNiTTLGt3+Sp8PJ7AsLW6Sv48l0EBCKG2BQMwcDl/aMg6mKjBIvQe
         J1KHXm/e5Pw90JC2wPztZ0h0kuoCqedlQGYlE=
Date: Mon, 30 Aug 2010 21:00:59 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: =?utf-8?B?7KGw7KCV7Jqx?= <jmanbal@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Is there a good documentation about CFS and CGROUP??
Message-ID: <20100830130059.GA2493@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <AANLkTinYE1EBR1nJSHcgY4Lu6sNAJYUh6w_cYm+8eydC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinYE1EBR1nJSHcgY4Lu6sNAJYUh6w_cYm+8eydC@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 07:02:48PM +0900, 조정욱 wrote:
> Is there a good documentation about CFS and CGROUP??

You can take a look at:
Documentation/scheduler/
Documentation/cgroups/

Thanks,
Yong

> 
> 
> end
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
