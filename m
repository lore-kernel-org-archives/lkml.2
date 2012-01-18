Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab2AROtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 09:49:19 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:62805 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757720Ab2AROtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 09:49:18 -0500
Date: Wed, 18 Jan 2012 09:46:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Greg KH <gregkh@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, cesarb@cesarb.net,
        kamezawa.hiroyu@jp.fujitsu.com, emunson@mgebm.net, aarcange@redhat.com,
        riel@redhat.com, mel@csn.ul.ie, rientjes@google.com, dima@android.com,
        rebecca@android.com, san@google.com, akpm@linux-foundation.org,
        vesa.jaaskelainen@nokia.com
Subject: Re: [PATCH v2 1/2] Making si_swapinfo exportable
Message-ID: <20120118144618.GA7438@phenom.dumpdata.com>
References: <cover.1326803859.git.leonid.moiseichuk@nokia.com>
 <56cc3c5d40a8653b7d9bef856ff02d909b98f36f.1326803859.git.leonid.moiseichuk@nokia.com>
 <CAOJsxLHfHHrFyhfkSe8mbsnJHBkgKtksCZZDwN6K3d7KJqfzkQ@mail.gmail.com>
 <20120118140904.GB13817@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120118140904.GB13817@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4F16DBC1.0128,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +EXPORT_SYMBOL(si_swapinfo);
> 
> EXPORT_SYMBOL_GPL() perhaps?

Greg,

So.. could you tell when are suppose to do _GPL and when not? Is there
a policy of "new code must be _GPL" ? Or is there some extra "if .. then"
conditions?

Thanks!
