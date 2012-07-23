Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab2GWLey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 07:34:54 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:57662 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750838Ab2GWLex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 07:34:53 -0400
X-Sasl-enc: rhO80Vow42ekMvnqWcDt8TGhOpSOutt8iZwBgbwe5osj 1343043292
Date: Mon, 23 Jul 2012 08:34:49 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Du, ChangbinX" <changbinx.du@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Do need keep mail in thread when sending a new version patch?
Message-ID: <20120723113449.GD9103@khazad-dum.debian.net>
References: <0C18FE92A7765D4EB9EE5D38D86A563A0B2DCF@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0C18FE92A7765D4EB9EE5D38D86A563A0B2DCF@SHSMSX101.ccr.corp.intel.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2012, Du, ChangbinX wrote:
> Hi, developers!
> 	I have a question about sending patch: If my patch have a new version, 
> do I need set "--in-reply-to" option so keep them in the same thread when
> sending it? And in which cases should "--in-reply-to" option be set? Thanks!

Yes, please do it when possible.  It groups patches nicely in theaded email
readers, and it makes it easier for people who are interested in the subject
to find the new version of your patchset (and all individual patches that
are part of the same patchset), AND for people who are not interested to
skip the entire thing.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
