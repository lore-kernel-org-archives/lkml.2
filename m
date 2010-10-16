Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab0JPPcg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 11:32:36 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57623 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab0JPPcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 11:32:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UFoiE851YX1BB+OtrCcYhyMvhzTi+GnmlUpFDBDCKUZaujTmbdgHaom14eZQVXvOjM
         8590IBgVYEpfRBdhulMTiEvEzOckTEyV5m0s0DDucShiCnYIbeSnK6eBCYO41jvM/fzs
         LOIEcvlJI+/FhyTY1Cys4Jn3HvUglTU3UwOWk=
Date: Sat, 16 Oct 2010 19:32:30 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Don Zickus <dzickus@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        mingo@elte.hu, fweisbec@gmail.com, robert.richter@amd.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] arch generic way to trigger unknown NMIs
Message-ID: <20101016153229.GA6763@lenovo>
References: <20101007030807.GA4076@redhat.com> <20101007072641.GE5010@basil.fritz.box> <20101007140112.GN10663@redhat.com> <alpine.LFD.2.00.1010072342170.15889@eddie.linux-mips.org> <20101010202357.GA28938@lenovo> <alpine.LFD.2.00.1010160822250.15889@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1010160822250.15889@eddie.linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 08:24:35AM +0100, Maciej W. Rozycki wrote:
> On Mon, 11 Oct 2010, Cyrill Gorcunov wrote:
> 
> > We have send_IPI_self which can't be used for NMI delivery mode (ie with
> > self shortland) but still can be used as say (didn't test)
> 
>  So what's stopping send_IPI_self() from being used for an NMI?  Can't the 
> function be updated/fixed to support these if there's a need?
> 
>   Maciej
> 

 Hi Maciej, the send_IPI_self could be modified to send NMI (at moment it
uses self shortcut with fixed delivery mode). The question is rather if
we need it without a real caller yet. When Don's patch gets merged we
will have a real caller then and could update send_IPI_self to support
NMI delivery mode. Something like that :)

  Cyrill
