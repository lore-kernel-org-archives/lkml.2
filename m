Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762065Ab2FHQXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 12:23:04 -0400
Received: from fias.uni-frankfurt.de ([141.2.248.1]:50746 "EHLO
	fias.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761986Ab2FHQXD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 12:23:03 -0400
Message-ID: <1339172599.26423.13.camel@tesla>
Subject: Re: [PATCH] uio_pci_generic does not export memory resources
From: Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 08 Jun 2012 18:23:19 +0200
In-Reply-To: <20120608155728.GB9705@local>
References: <1339156616.3870.9.camel@blech>
	 <20120608130351.GB1964@redhat.com> <1339165738.3870.18.camel@blech>
	 <20120608151843.GA9705@local> <1339170312.26423.6.camel@tesla>
	 <20120608155728.GB9705@local>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 08.06.2012, 17:57 +0200 schrieb Hans J. Koch:
> What problem do you have with this approach?

Nothing itself. There is obviously a documentation issue, which really
confuses people who are new to that stuff. I thought that fixing it, by
just adding a view lines of code (really a view, when I remove the DMA
masque part) might enhance this particular module. 

Anyway, what is wrong when the uio_pci_generic module works like
described in the related documentation? 

-- 
Gruß
  Dominic

Frankfurt Institute for Advanced Studies (FIAS)
Ruth-Moufang-Straße 1
D-60438 Frankfurt am Main
Germany

Phone:  +49 (0)

