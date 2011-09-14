Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab1INKPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 06:15:31 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:45131 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755990Ab1INKPa convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@suse.com:6:1>);
	Wed, 14 Sep 2011 06:15:30 -0400
Message-Id: <4E709ADE0200007800056002@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 14 Sep 2011 11:15:26 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <jaxboe@fusionio.com>, "Jeremy Fitzhardinge" <jeremy@goop.org>,
        <hch@infradead.org>, "Jan Kara" <jack@suse.cz>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Help with implementing some form of barriers in 3.0
	 kernels.
References: <20110907174832.GN32190@dumpdata.com>
 <4E6F50170200007800055CF5@nat28.tlf.novell.com>
 <20110914085913.GB25628@phenom.oracle.com>
 <4E708C240200007800055FDF@nat28.tlf.novell.com>
 <20110914093019.GA15866@phenom.oracle.com>
In-Reply-To: <20110914093019.GA15866@phenom.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 14.09.11 at 11:30, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>> >     [v1: Added some extra functions, and other cases]
>> 
>> Ah, yes, of course - Jan probably didn't pay attention because in our
>> variant of the driver these functions never got removed.
> 
> <nods> Which is OK - but you might want to migrate in the the 
> 'feature-write-flush'

We really have both. I just never removed the barrier one.

Jan

