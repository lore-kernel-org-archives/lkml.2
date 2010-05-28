Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151Ab0E1DMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 23:12:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:58769 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758888Ab0E1DMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 23:12:19 -0400
Date: Thu, 27 May 2010 20:14:39 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Igor Stoppa <igor.stoppa@nokia.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>, Brown <len.brown@intel.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Len@smtp1.linux-foundation.org" <Len@smtp1.linux-foundation.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 8/8] intel_idle: create a native cpuidle
 driver for select intel processors
Message-ID: <20100527201439.6d0fd169@infradead.org>
In-Reply-To: <4BFE86D4.60602@nokia.com>
References: <1274928151-30919-1-git-send-email-lenb@kernel.org>
	<e099975ca65a7f6ac7f8bc3fee84d3e03893aa31.1274926772.git.len.brown@intel.com>
	<198450ec1600d9a7f55270dd4d44d6b55bc5b184.1274926772.git.len.brown@intel.com>
	<87ljb5l9d5.fsf@deeprootsystems.com>
	<20100527072207.2e783b1e@infradead.org>
	<4BFE86D4.60602@nokia.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010 17:51:00 +0300
Igor Stoppa <igor.stoppa@nokia.com> wrote:

> Hi,
> 
> 
> ext Arjan van de Ven wrote:
> 
> > it's really inconvenient to have such drivers hidden in the
> > architecture code; it's much more convenient for cpuidle developers
> > if they're all in one place.
> >   
> 
> why?

because you have all the users of your API in one place.

