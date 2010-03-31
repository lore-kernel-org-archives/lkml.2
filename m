Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab0CaFBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 01:01:46 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:60103 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab0CaFBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 01:01:43 -0400
Date: Wed, 31 Mar 2010 00:01:32 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/6] sysfs: Basic support for multiple super blocks
Message-ID: <20100331050132.GA10787@us.ibm.com>
References: <m1fx3hk6gw.fsf@fess.ebiederm.org>
 <1269973889-25260-1-git-send-email-ebiederm@xmission.com>
 <20100331050100.GB10144@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100331050100.GB10144@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge E. Hallyn (serue@us.ibm.com):
> Quoting Eric W. Biederman (ebiederm@xmission.com):
> > From: Eric W. Biederman <ebiederm@xmission.com>
> > 
> > Add all of the necessary bioler plate to support
> > multiple superblocks in sysfs.
> > 
> > Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> 
> Acked-by: Serge Hallyn <serue@us.ibm.com>

(with the patch 7/6 of course :)
