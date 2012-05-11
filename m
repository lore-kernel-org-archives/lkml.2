Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606Ab2EKBXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 21:23:20 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:42089 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab2EKBXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 21:23:18 -0400
Date: Fri, 11 May 2012 09:23:09 +0800
From: Richard Yang <weiyang@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Richard Yang <weiyang@linux.vnet.ibm.com>,
        Wei Yang <weiyang.kernel@gmail.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: One problem in reassign pci bus number?
Message-ID: <20120511012309.GA5392@richard>
Reply-To: Richard Yang <weiyang@linux.vnet.ibm.com>
References: <CAE9FiQWM4OTFp5NN+KOXxNREQxNWipDjWbbPPiHHJsb6yFmuiQ@mail.gmail.com>
 <20120506151715.GA7773@richard>
 <CAE9FiQWsSWK-_zGe1ggaKuZu+RJ1kb1zuTEokdxqFSbE3UjNRw@mail.gmail.com>
 <CAE9FiQXKjxLDLeh8TXU_OCNwFt+UMv3qFjcPrKcPcorA1YmkdQ@mail.gmail.com>
 <20120507011722.GA8122@richard>
 <CAE9FiQUpcJdAvK=wisNc_zq5c9zDtgEM=MNugDcHN9h3=ZPUcA@mail.gmail.com>
 <20120508024612.GA11485@richard>
 <CAE9FiQUU+a4yQJTiud=aYx2xXcoQZpH2rJyVhj19TQKGN7=2BA@mail.gmail.com>
 <20120510033551.GA25138@richard>
 <CAE9FiQXcFC-5VKGVDZc6Tb8Nw8cLG4sB=BEP-+zctf2c6n6oNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQXcFC-5VKGVDZc6Tb8Nw8cLG4sB=BEP-+zctf2c6n6oNg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12051101-3864-0000-0000-000002BBB7C6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 10:42:06PM -0700, Yinghai Lu wrote:
>
>We can not extend start.
>
>when we have bridge using [90, 150] all children devices will be on bus 90.
>if change the bridge to use low like 81, then all device need to
>remove and rescan them.
>
>also keep the old bus number is safer.
Oh, got it. 
>
>Yinghai

-- 
Richard Yang
Help you, Help me

