Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab1C2VOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 17:14:46 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:61414 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab1C2VOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 17:14:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=xQPwVMSMny4kcRMtkEIBnFFY8UyIXQcyQlkwJpDU0l3G8LdvOW8NexEz4a85Zozrzw
         41zaAE7dF0Dj6NNsA9G55uEbIWw6G5QsxF8tjuSGef5jGDpPr0cl9K8oM8+hyYoDCvji
         KNIPsgdLAZuJ++mtK18gCoKKKOT15qBt5BMfU=
Date: Tue, 29 Mar 2011 18:14:37 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Michael Witten <mfwitten@gmail.com>
Cc: Raghavendra D Prabhu <rprabhu@wnohang.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use the environment variable PYTHON if defined
Message-ID: <20110329211437.GB20824@ghostprotocols.net>
References: <20110326224408.GA1336@Xye>
 <20110328144721.GB17872@ghostprotocols.net>
 <e987828e-87ec-4973-95e7-47f10f5d9bab-mfwitten@gmail.com>
 <20110329181524.GA5140@Xye>
 <AANLkTi=3Wq3Xt-QFR-FLRQ1kBjpWjaBZNFpOiE_T15WH@mail.gmail.com>
 <20110329204024.GA20824@ghostprotocols.net>
 <AANLkTinmXdmNX+iCB4svo3QqR6AcwGrasziFJPeu0J=M@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinmXdmNX+iCB4svo3QqR6AcwGrasziFJPeu0J=M@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Mar 29, 2011 at 04:02:07PM -0500, Michael Witten escreveu:
> On Tue, Mar 29, 2011 at 15:40, Arnaldo Carvalho de Melo
> <acme@ghostprotocols.net> wrote:
> > I think that the best course of action is to emit a warning and go
> 
> Good.
> 
> I'll make it so!

Thanks.
