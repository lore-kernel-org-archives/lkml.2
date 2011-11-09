Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab1KITaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 14:30:55 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:43168 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756575Ab1KITaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 14:30:55 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 4uJXCekVM1knJSHgwFl5SBLQvK.bnEFyJWW5rAt2f0w8uJj
 5ZCLdZVm5gOQvg6eygK4O33xvm5F075dx0XONTqon6IOv5gV19GCJH.I71FY
 obzSgTYUHo0hvh1bB8TwxB4V14ULczfM95vmqyO92603zYj3wDbHPjBLokVQ
 jnOD2UXZfEh9UnP.i_4EK9pM3ayaSbxwHiA5rxSu4yFc0l9KciaBxJ81J8M2
 bKfFcrSmHEBlq8coBQBEzCBG2_kPpHQeVLFAeKriBIeFJbKFvTLe6ysFEb1N
 SQMj8rN3obSL5RMSFiYP3YPmjA2B9hbvsVRP7MW6t_587CfEmFG_a055o_0X
 2tPn0uJywIX0Ywc.AXdLVf4S65v4senwi4oUkg6ZJ9L2E
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 9 Nov 2011 13:30:52 -0600 (CST)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch 1/2] slab: rename slab_break_gfp_order to
 slab_max_order
In-Reply-To: <CAOJsxLGOhW3tLTCZZw3VKoxd4Cg8ZN66ACj1vW3yQAFRenm3-A@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1111091330280.19817@router.home>
References: <alpine.DEB.2.00.1110182207500.5907@chino.kir.corp.google.com> <alpine.DEB.2.00.1111031440130.31612@chino.kir.corp.google.com> <CAOJsxLGOhW3tLTCZZw3VKoxd4Cg8ZN66ACj1vW3yQAFRenm3-A@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Nov 2011, Pekka Enberg wrote:

> The patches seem reasonable to me. Christoph?

Looks good and makes the two allocators to behave similarly.

Acked-by: Christoph Lameter <cl@linux.com>

