Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab2INNdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:33:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16284 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab2INNdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:33:04 -0400
X-Authority-Analysis: v=2.0 cv=VPlfbqzX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ZDDkTe9yP_wA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=cf0L7CG27rcA:10 a=mDV3o1hIAAAA:8 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8 a=yWGnIIe_ebuLAofsvJMA:9 a=PUjeQqilurYA:10 a=lM8EmwarS4gA:10 a=MSl-tDqOz04A:10 a=3Rfx1nUSh_UA:10 a=jeBq3FmKZ4MA:10 a=xrf48phdYvfyvlb8:21 a=zh2BkHmXDenowtv6:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1347629582.10751.90.camel@gandalf.local.home>
Subject: Re: [PATCH 1/2] Update FSF postal address to be URL's.
From: Steven Rostedt <rostedt@goodmis.org>
To: Jon Stanley <jonstanley@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Fri, 14 Sep 2012 09:33:02 -0400
In-Reply-To: <1347049967-3143-1-git-send-email-jonstanley@gmail.com>
References: <1347049967-3143-1-git-send-email-jonstanley@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 16:32 -0400, Jon Stanley wrote:
> The FSF now prefers to use URL's in copyright headers rather than
> their postal address. This change updates the address to be
> <http://www.gnu.org/licenses> per http://www.gnu.org/licenses/gpl-howto.html
> 
> Signed-off-by: Jon Stanley <jonstanley@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

Arnaldo, can you pull these patches into your queue.

Thanks,

-- Steve

> ---
>  tools/lib/traceevent/event-parse.c  |    3 +--
>  tools/lib/traceevent/event-parse.h  |    3 +--
>  tools/lib/traceevent/event-utils.h  |    3 +--
>  tools/lib/traceevent/parse-filter.c |    3 +--
>  tools/lib/traceevent/trace-seq.c    |    3 +--
>  5 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index 5f34aa3..7b946f9 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -13,8 +13,7 @@
>   * GNU Lesser General Public License for more details.
>   *
>   * You should have received a copy of the GNU Lesser General Public
> - * License along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> + * License along with this program; if not,  see <http://www.gnu.org/licenses>
>   *
>   * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   *
> diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
> index 5772ad8..ea93a1a 100644
> --- a/tools/lib/traceevent/event-parse.h
> +++ b/tools/lib/traceevent/event-parse.h
> @@ -13,8 +13,7 @@
>   * GNU Lesser General Public License for more details.
>   *
>   * You should have received a copy of the GNU Lesser General Public
> - * License along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> + * License along with this program; if not,  see <http://www.gnu.org/licenses>
>   *
>   * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   */
> diff --git a/tools/lib/traceevent/event-utils.h b/tools/lib/traceevent/event-utils.h
> index 0829638..ebd970c 100644
> --- a/tools/lib/traceevent/event-utils.h
> +++ b/tools/lib/traceevent/event-utils.h
> @@ -13,8 +13,7 @@
>   * GNU Lesser General Public License for more details.
>   *
>   * You should have received a copy of the GNU Lesser General Public
> - * License along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> + * License along with this program; if not,  see <http://www.gnu.org/licenses>
>   *
>   * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   */
> diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
> index ad17855..5527c32 100644
> --- a/tools/lib/traceevent/parse-filter.c
> +++ b/tools/lib/traceevent/parse-filter.c
> @@ -13,8 +13,7 @@
>   * GNU Lesser General Public License for more details.
>   *
>   * You should have received a copy of the GNU Lesser General Public
> - * License along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> + * License along with this program; if not,  see <http://www.gnu.org/licenses>
>   *
>   * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   */
> diff --git a/tools/lib/traceevent/trace-seq.c b/tools/lib/traceevent/trace-seq.c
> index b1ccc92..a57db80 100644
> --- a/tools/lib/traceevent/trace-seq.c
> +++ b/tools/lib/traceevent/trace-seq.c
> @@ -13,8 +13,7 @@
>   * GNU Lesser General Public License for more details.
>   *
>   * You should have received a copy of the GNU Lesser General Public
> - * License along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> + * License along with this program; if not,  see <http://www.gnu.org/licenses>
>   *
>   * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   */


