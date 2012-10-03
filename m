Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932824Ab2JCALF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 20:11:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932810Ab2JCALD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 20:11:03 -0400
Date: Tue, 2 Oct 2012 17:11:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/10] Introduce huge zero page
Message-Id: <20121002171101.636cc1b0.akpm@linux-foundation.org>
In-Reply-To: <20121003000402.GA31141@shutemov.name>
References: <1349191172-28855-1-git-send-email-kirill.shutemov@linux.intel.com>
	<20121002153148.1ae1020a.akpm@linux-foundation.org>
	<20121003000402.GA31141@shutemov.name>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Oct 2012 03:04:02 +0300
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> Is the overview complete enough? Have I answered all you questions here?

Yes, thanks!

The design overview is short enough to be put in as code comments in
suitable places.
