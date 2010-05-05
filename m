Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686Ab0EEESf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 00:18:35 -0400
Received: from mail-iw0-f203.google.com ([209.85.223.203]:61280 "EHLO
	mail-iw0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab0EEESd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 00:18:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=P6p5IsJdNLQ1/Rn5gimXP0rne8dCgYBJNZrDQiA89DFOZY2Qi1q+1laFRZlC+neM4o
         tljMavsiRqzz0prMEiCqnpeDE9UQ3pcQLf0eugnhxkgOVcO/Za8F9+DeLG1qVjLFbKMT
         oyuyKz2GRcUpDgAn2bgQbPXFYxL8aqbr/yBqc=
Subject: Re: [PATCH 2/3] perf inject: Add missing bits
From: Tom Zanussi <tzanussi@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1272981607-28723-3-git-send-email-acme@infradead.org>
References: <1272981607-28723-1-git-send-email-acme@infradead.org>
	 <1272981607-28723-3-git-send-email-acme@infradead.org>
Content-Type: text/plain
Date: Tue, 04 May 2010 23:18:30 -0500
Message-Id: <1273033110.6383.41.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-04 at 11:00 -0300, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> New commands need to have Documentation and be added to command-list.txt
> so that they can appear when 'perf' is called withouth any subcommand:
> 

Thanks for adding this!

Tom


