Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab0HWXXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 19:23:42 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62346 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab0HWXXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 19:23:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:x-url:user-agent;
        b=sfJKbxGCHobVPnENo7Q8KodTxQMFhHlATUmfhTlqsx65Sog9r6m13WM5GJ41UpLiJD
         am2nzvuGNK5kyZJfEdILjitoL9PlhJKNMF/0/SZlKhuTM5rFu9Mwkk9k1Smm/QKU9ydW
         m4kebtf25xiZoK50URs+QMsoOU40Ah9R7PAy0=
Date: Mon, 23 Aug 2010 20:23:34 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu
Subject: Re: [PATCH] perf tools: Fix linking errors with --as-needed flag
Message-ID: <20100823232334.GE2761@ghostprotocols.net>
References: <1279449937-29115-1-git-send-email-ozan@pardus.org.tr>
 <4C42DFC0.1090708@pardus.org.tr>
 <20100821172433.GF2973@ghostprotocols.net>
 <1282459432.11398.53.camel@tropicana>
 <1282531453.30047.8.camel@tropicana>
 <20100823143839.GA2761@ghostprotocols.net>
 <4C72E6AF.9060102@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C72E6AF.9060102@pardus.org.tr>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Aug 24, 2010 at 12:22:55AM +0300, Ozan Çağlayan escreveu:
> On 23.08.2010 17:38, Arnaldo Carvalho de Melo wrote:
> > Em Sun, Aug 22, 2010 at 09:44:13PM -0500, Tom Zanussi escreveu:
> >> Looking into it a bit further, both ExtUtils::Embed -e ldopts and
> >> python-config --ldflags put the libs at the end, so we should be able to
> >> parse the output of those and take only the parts we need for each
> >> component.  How about something like this instead?
> > 
> > Ozan, Kirill, can you please test Tom's patch and see if it fixes the
> > problems you noticed so that I can add Tested-by tags and apply this
> > patch?
> 
> Hi,
> 
> I won't be able to test anything for at least 1 week, sorry.

np, take your time.

- Arnaldo
