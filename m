Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab1JRWd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 18:33:26 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25231 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab1JRWdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 18:33:24 -0400
Date: Wed, 19 Oct 2011 01:28:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Nathan Fontenot <nfont@austin.ibm.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, kernel-janitors@vger.kernel.org
Subject: Re: [patch] memory hotplug: release lock on an error path
Message-ID: <20111018222805.GB24215@longonot.mountain>
References: <20111005055326.GA32187@elgon.mountain>
 <20111018212931.GB10656@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111018212931.GB10656@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4E9DFE23.0186,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 02:29:32PM -0700, Michal Hocko wrote:
> On Wed 05-10-11 08:53:26, Dan Carpenter wrote:
> > We need to release the mutex here before returning.
> 
> Which kernel have you used as a base? I do not see any code like that in
> the vanilla kernel. And git log doesn't know anything about
> check_page_reservations in the file as well...
> 

Sorry this was against linux-next.

regards,
dan carpenter

