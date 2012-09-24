Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab2IXUyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 16:54:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36784 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187Ab2IXUyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 16:54:37 -0400
Date: Mon, 24 Sep 2012 13:54:32 -0700
From: Tejun Heo <tj@kernel.org>
To: Deepawali Verma <dverma249@gmail.com>
Cc: Chinmay V S <cvs268@gmail.com>, Daniel Taylor <Daniel.Taylor@wdc.com>,
        anish singh <anish198519851985@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Work queue questions
Message-ID: <20120924205432.GE29689@google.com>
References: <CAK7N6vpLpNM-tfhxpmym_eW+VpF+jnBe+uB=E0mSBk+CtMWp+w@mail.gmail.com>
 <5A9BC72FD5CEC94EA024CED8E31D701A4C572FAE@wdscexmb03.sc.wdc.com>
 <CAHCeSFp2=CzO1-dw_Ym_s4Pn04nsC_kQUerFJ+uFLh8iinX+Ug@mail.gmail.com>
 <CAK-9PRB7KvPNgcsXiNG08-7OdrkkNc2ushusXh9rVm93J0xcHA@mail.gmail.com>
 <CAHCeSFqmeOkKySxMUXgtnev+HL-NC6MdmeuDYONymYaNczb7RA@mail.gmail.com>
 <CAHCeSFq31fQuZd+Phgx-dQ1AEeDTh268WH14bDqEKqneOLpqxQ@mail.gmail.com>
 <20120924181025.GG7694@google.com>
 <CAHCeSFr4stF6BNGL7=7oPYzKqOZ-Ya8VUD02rjFRq1thMULFXw@mail.gmail.com>
 <20120924200809.GC29689@google.com>
 <CAHCeSFpYZRVasw26q01HO7fj9972wdNiTV0mikiNUuDMi9M0sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHCeSFpYZRVasw26q01HO7fj9972wdNiTV0mikiNUuDMi9M0sw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 09:52:14PM +0100, Deepawali Verma wrote:
> I do not have ordering as requirement. I can use system work queue as
> well. what is max_active by default for system wq per cpu?

For system_unbound_wq, it's the larger one of 512 and 4 * #cpus.

-- 
tejun
