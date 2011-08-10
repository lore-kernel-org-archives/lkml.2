Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751075Ab1HJGqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 02:46:42 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:3880 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab1HJGql convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:12:1>);
	Wed, 10 Aug 2011 02:46:41 -0400
Message-Id: <4E4245A8020000780005084E@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 10 Aug 2011 07:47:36 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Dan Magenheimer" <dan.magenheimer@oracle.com>
Cc: <hannes@cmpxchg.org>, <jackdachef@gmail.com>, <hughd@google.com>,
        <jeremy@goop.org>, <npiggin@kernel.dk>, <linux-mm@kvack.org>,
        <akpm@linux-foundation.org>, <sjenning@linux.vnet.ibm.com>,
        "Chris Mason" <chris.mason@oracle.com>,
        "Konrad Wilk" <konrad.wilk@oracle.com>,
        "Kurt Hackel" <kurt.hackel@oracle.com>, <riel@redhat.com>,
        <ngupta@vflare.org>, <linux-kernel@vger.kernel.org>, <matthew@wil.cx>
Subject: RE: Subject: [PATCH V6 1/4] mm: frontswap: swap data structure
	 changes
References: <20110808204555.GA15850@ca-server1.us.oracle.com>
 <4E414320020000780005057E@nat28.tlf.novell.com><4E414320020000780005057E@nat28.tlf.novell.com>
 <ce8cba73-ec3c-42ae-849a-11db1df8ffa3@default
 4E4179D90200007800050676@nat28.tlf.novell.com><4E4179D90200007800050676@nat28.tlf.novell.com>
 <747e657f-24be-41ed-a251-36116c8a6a13@default>
In-Reply-To: <747e657f-24be-41ed-a251-36116c8a6a13@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 09.08.11 at 19:43, Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> Anyway, unless you feel very strongly about this, I'm
> inclined to not add the ifdef to the struct for the
> reasons previously stated.

No, I don't feel really strongly about this - it you can get it accepted with
the minor overhead, that's fine to me. It's just that for integration into
our kernels (i.e. until these get accepted upstream) I chose to do those
adjustments to avoid possible complaints.

Jan

