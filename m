Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab1BPQzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 11:55:10 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57882 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab1BPQzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 11:55:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=j59OJN9NFmunP1pJBTRZaulC4ONUQaV2N09dYI7Af3rDaPqjvOQlHyUPFOUP6rcP8n
         DgzdQ30aXPcvA0x4piAwluN//Jlzv+rFxEMulIK4aLoQR7RidI29O13qpuAGvHBL6cgY
         Sv0IPc3NNMPFSCkUg6A+xGuK0yIB/q2vhHFU4=
Date: Wed, 16 Feb 2011 17:55:02 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Regression with dataloss: Reiserfs deadlock in 2.6.36 and
 2.6.37, know working 2.6.33
Message-ID: <20110216165456.GA3090@nowhere>
References: <201011181650.00152.roucaries.bastien@gmail.com>
 <20101223034229.GF1739@nowhere>
 <201101300108.32383.roucaries.bastien@gmail.com>
 <201102161722.24963.roucaries.bastien@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201102161722.24963.roucaries.bastien@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 05:22:21PM +0100, Bastien ROUCARIES wrote:
> Le dimanche 30 janvier 2011 01:08:29, Bastien ROUCARIES a écrit :
> > Le jeudi 23 décembre 2010 04:42:33, Frederic Weisbecker a écrit :
> > Hi,
> > 
> Dear Andrew,
> 
> Since three month I suffer fo regular dataloss in reiserfs kernel. I have posted all the detail  on #29162 under bugzilla.
> 
> This bug freeze my notebook every hour between 6 hours. using git pull and compiling kernel seems to exercice this bugs.
> 
> Frederic is really busy by academic millestones and I really thank him for his previous help, do you know somebody willing to 
> help?
> 
> I could test some patch if needed.
> 
> Thank you
> 
> Bastien

Note, in the beginning of march, I'll have time to handle that again, in case nobody else shows
up until then.
