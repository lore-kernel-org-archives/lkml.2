Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab0JMUne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 16:43:34 -0400
Received: from canuck.infradead.org ([134.117.69.58]:51576 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab0JMUnd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 16:43:33 -0400
Subject: Re: [RFC PATCH 1/9] uaccess: Make copy_from_user_nmi() globally
 available
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
In-Reply-To: <20101013144734.GB5335@nowhere>
References: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com>
	 <1286946421-32202-2-git-send-regression-fweisbec@gmail.com>
	 <1286954156.29097.53.camel@twins>  <20101013144734.GB5335@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 13 Oct 2010 22:43:14 +0200
Message-ID: <1287002594.29097.136.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-13 at 16:47 +0200, Frederic Weisbecker wrote:
> Ok, I'll do the rename. Does that work on any arch?

On any arch that implements __get_user_pages_fast() which is only x86
atm, but any arch that supports get_user_pages_fast() could do it.


