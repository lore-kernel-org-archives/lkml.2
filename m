Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab2GWR3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 13:29:48 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:46813 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753828Ab2GWR3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 13:29:47 -0400
Message-ID: <500D89D0.8080005@xenotime.net>
Date: Mon, 23 Jul 2012 10:28:48 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: "Du, ChangbinX" <changbinx.du@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Do need keep mail in thread when sending a new version patch?
References: <0C18FE92A7765D4EB9EE5D38D86A563A0B2DCF@SHSMSX101.ccr.corp.intel.com> <20120723113449.GD9103@khazad-dum.debian.net>
In-Reply-To: <20120723113449.GD9103@khazad-dum.debian.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2012 04:34 AM, Henrique de Moraes Holschuh wrote:

> On Mon, 23 Jul 2012, Du, ChangbinX wrote:
>> Hi, developers!
>> 	I have a question about sending patch: If my patch have a new version, 
>> do I need set "--in-reply-to" option so keep them in the same thread when
>> sending it? And in which cases should "--in-reply-to" option be set? Thanks!
> 
> Yes, please do it when possible.  It groups patches nicely in theaded email
> readers, and it makes it easier for people who are interested in the subject
> to find the new version of your patchset (and all individual patches that
> are part of the same patchset), AND for people who are not interested to
> skip the entire thing.
> 


Please compare to a proposed patch:

  http://marc.info/?l=linux-doc&m=133539116205348&w=2


-- 
~Randy
